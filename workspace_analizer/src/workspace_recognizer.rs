use super::util::{get_parent_dir, get_resource_name};
use regex::Regex;
use std::collections::HashMap;
use walkdir::{DirEntry, WalkDir};

#[derive(Debug)]
pub struct ApplicationType {
    pub name: String,
    pub resources: Vec<String>,
}

#[derive(Debug)]
pub struct RecognizedApplication {
    pub name: String,
    pub path: String,
}

pub fn get_recognized_applications(
    path: &String,
    depth: &usize,
    application_types: &Vec<ApplicationType>,
) -> Vec<RecognizedApplication> {
    fn is_hidden(entry: &DirEntry) -> bool {
        entry
            .file_name()
            .to_str()
            .map(|s| s.starts_with("."))
            .unwrap_or(false)
    }

    let walker = WalkDir::new(path)
        .min_depth(1)
        .max_depth(*depth)
        .into_iter();

    let mut directories_map: HashMap<String, Vec<String>> = HashMap::new(); // <parent_dir, folder_list>
    let mut recognized_applications: Vec<RecognizedApplication> = Vec::new();

    let mut previous_parent_dir = String::from("");

    for entry in walker.filter_entry(|e| !is_hidden(e)) {
        if let Ok(entry) = entry {
            let parent_dir = get_parent_dir(&entry.path().display().to_string());
            let resource_name = get_resource_name(&entry.path().display().to_string());

            if previous_parent_dir.is_empty() {
                previous_parent_dir = parent_dir.clone();
            }

            if previous_parent_dir != parent_dir {
                // if the parent directory changes, update the previous one
                previous_parent_dir = parent_dir.clone();
            }

            directories_map
                .entry(parent_dir)
                .or_insert_with(Vec::new)
                .push(resource_name);
        }
    }

    // Recognize the application for each unique directory
    for (parent_dir, folder_list) in directories_map {
        let name = recognize_application(folder_list.clone(), &application_types);
        if let Some(name) = name {
            recognized_applications.push(RecognizedApplication {
                name,
                path: parent_dir.clone(),
            });
        }
    }

    recognized_applications
}

fn recognize_application(
    folder_list: Vec<String>,
    application_types: &Vec<ApplicationType>,
) -> Option<String> {
    let mut recognized_application: Option<String> = None;

    for application_type in application_types {
        let mut recognized = false;
        let len_application_resources = application_type.resources.len();
        let mut num_recognized_resources = 0;

        for resource in &folder_list {
            if validate_file_name_regex(resource, &application_type.resources) {
                num_recognized_resources += 1;
            }
        }

        if num_recognized_resources == len_application_resources {
            recognized_application = Some(application_type.name.clone());
            break;
        }
    }

    match recognized_application {
        Some(name) => Some(name),
        None => None,
    }
}

fn validate_file_name_regex(file_name: &String, folder_list: &Vec<String>) -> bool {
    let file_resource_name = get_resource_name(file_name);
    let re = Regex::new(&format!(r"{}", file_resource_name)).unwrap();

    for folder in folder_list {
        let folder_resource_name = get_resource_name(folder);
        if re.is_match(&folder_resource_name) {
            return true;
        }
    }
    false
}
