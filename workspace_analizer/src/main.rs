use clap::{builder::Str, Parser};
use std::collections::HashMap;
use std::path::Path;
use walkdir::{DirEntry, WalkDir};

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    /// path to analyze
    #[arg(short = 'p', long, default_value_t = String::from("."))]
    path: String,

    /// depth of the recursive search
    #[arg(short = 'd', long, default_value_t = 1)]
    depth: usize,

    /// list of ignored directories and files
    #[arg(short = 'i', long)]
    ignore: Vec<String>, // not implemented yet
}

#[derive(Debug)]
struct ApplicationType {
    name: String,
    files: Vec<String>,
    directories: Vec<String>,
}

#[derive(Debug)]
struct RecognizedApplication {
    name: String,
    path: String,
}

fn main() {
    let args = Args::parse();

    print!("{:?}\n", args);

    let application_types: Vec<ApplicationType> = vec![ApplicationType {
        name: String::from("Rust"),
        files: vec![String::from("Cargo.toml"), String::from("Cargo.lock")],
        directories: vec![String::from("target"), String::from("src")],
    }];

    dbg!(&application_types);

    let recognized_applications: Vec<RecognizedApplication> =
        get_recognized_applications(&args.path, &args.depth, &application_types);

    dbg!(recognized_applications);
}

fn get_recognized_applications(
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

    let mut directories_map: HashMap<String, Vec<String>> = HashMap::new();
    let mut recognized_applications: Vec<RecognizedApplication> = Vec::new();

    let mut previous_parent_dir = String::from("");

    for entry in walker.filter_entry(|e| !is_hidden(e)) {
        if let Ok(entry) = entry {
            let parent_dir = get_parent_dir(entry.path().display().to_string());
            let resource_name = get_resource_name(entry.path().display().to_string());

            if previous_parent_dir.is_empty() {
                previous_parent_dir = parent_dir.clone();
            }

            if previous_parent_dir != parent_dir {
                if let Some(folder_list) = directories_map.get(&previous_parent_dir) {
                    let name = recognize_application(folder_list.clone(), &application_types);
                    if let Some(name) = name {
                        recognized_applications.push(RecognizedApplication {
                            name: name,
                            path: previous_parent_dir.clone(),
                        });
                    }
                }
                previous_parent_dir = parent_dir.clone();
            }

            directories_map
                .entry(parent_dir)
                .or_insert_with(Vec::new)
                .push(resource_name);
        }
    }

    // Reconocer la aplicación para el último directorio
    if let Some(folder_list) = directories_map.get(&previous_parent_dir) {
        let name = recognize_application(folder_list.clone(), &application_types);
        if let Some(name) = name {
            recognized_applications.push(RecognizedApplication {
                name: name,
                path: previous_parent_dir.clone(),
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
        let mut recognized = true;

        for file in &application_type.files {
            if !folder_list.contains(file) {
                recognized = false;
                break;
            }
        }

        if recognized {
            for directory in &application_type.directories {
                if !folder_list.contains(directory) {
                    recognized = false;
                    break;
                }
            }
        }

        if recognized {
            recognized_application = Some(application_type.name.clone());
            break;
        }
    }

    match recognized_application {
        Some(name) => Some(name),
        None => None,
    }
}

fn get_parent_dir(path: String) -> String {
    let path = Path::new(&path);
    if let Some(parent) = path.parent() {
        parent.to_str().unwrap_or("").to_string()
    } else {
        "".to_string()
    }
}

fn get_resource_name(path: String) -> String {
    let path = Path::new(&path);
    path.file_name().unwrap().to_str().unwrap_or("").to_string()
}
