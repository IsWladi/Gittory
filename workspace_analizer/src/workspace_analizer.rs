use super::util::{get_parent_dir, get_resource_name};
use regex::Regex;
use std::collections::HashMap;
use walkdir::{DirEntry, WalkDir};

use serde::{Deserialize, Serialize};
use serde_json::Result;

#[derive(Debug)]
pub struct ApplicationType {
    pub name: String,
    pub resources: Vec<String>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RecognizedApplication {
    pub name: String,
    pub path: String,
}

/// Function to get the recognized applications in the specified path
/// path: path to search for recognized applications
/// depth: depth of the search
/// application_types: list of application types to recognize
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

/// Function to recognize the application based on the resources in the folder
/// folder_list: list of resources in the folder
/// application_types: list of application types to recognize
fn recognize_application(
    folder_list: Vec<String>,
    application_types: &Vec<ApplicationType>,
) -> Option<String> {
    let mut recognized_application: Option<String> = None;

    for application_type in application_types {
        let len_application_resources = application_type.resources.len();
        let mut num_recognized_resources = 0;

        for resource in &folder_list {
            if validate_file_name_regex(resource, &application_type.resources) {
                num_recognized_resources += 1;
            }
        }

        if num_recognized_resources >= len_application_resources {
            recognized_application = Some(application_type.name.clone());
            break;
        }
    }

    match recognized_application {
        Some(name) => Some(name),
        None => None,
    }
}

/// Function to validate if the file is at least one of the resources in the folder
/// file_name: name of the file to validate
/// folder_list: list of resources in the folder
fn validate_file_name_regex(file_name: &String, folder_list: &Vec<String>) -> bool {
    let file_resource_name = get_resource_name(file_name);

    for folder in folder_list {
        let re = Regex::new(&format!(r"{}", folder)).unwrap();
        if re.is_match(&file_resource_name) {
            return true;
        }
    }
    false
}

pub fn print_recognized_applications(
    recognized_applications: &Vec<RecognizedApplication>,
) -> Result<()> {
    let json = serde_json::to_string(&recognized_applications)?;
    println!("{}", json);
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_validate_file_name_regex() {
        let file_name = String::from("main.rs");
        let folder_list = vec![String::from(r".+\.rs"), String::from("src")];
        assert_eq!(validate_file_name_regex(&file_name, &folder_list), true);

        let file_name = String::from("src");
        assert_eq!(validate_file_name_regex(&file_name, &folder_list), true);
    }

    #[test]
    fn test_recognize_application() {
        let folder_list = vec![
            String::from("Cargo.toml"),
            String::from("Cargo.lock"),
            String::from("target"),
            String::from("src"),
            String::from("tests"),
        ];
        let application_types: Vec<ApplicationType> = vec![
            ApplicationType {
                name: String::from("Rust Crate"),
                resources: vec![
                    String::from("Cargo.toml"),
                    String::from("Cargo.lock"),
                    String::from("target"),
                    String::from("src"),
                ],
            },
            ApplicationType {
                name: String::from("Qmk Keymap"),
                resources: vec![String::from("keymap.c"), String::from("config.h")],
            },
        ];
        assert_eq!(
            recognize_application(folder_list, &application_types),
            Some(String::from("Rust Crate"))
        );

        let folder_list = vec![String::from("keymap.c")];
        assert_eq!(recognize_application(folder_list, &application_types), None);
    }

    #[test]
    fn test_get_recognized_applications() {
        let path = String::from("./src"); // this test can fail if the current directory is not the root of the project
        let depth = 1;
        let application_types: Vec<ApplicationType> = vec![ApplicationType {
            name: String::from("Rust files"),
            resources: vec![String::from(r".+\.rs")],
        }];
        let recognized_applications: Vec<RecognizedApplication> =
            get_recognized_applications(&path, &depth, &application_types);

        assert_eq!(recognized_applications.len(), 1);
        assert_eq!(recognized_applications[0].name, "Rust files");
    }
}
