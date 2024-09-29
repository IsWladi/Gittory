use clap::Parser;
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

struct ApplicationType {
    name: String,
    files: Vec<String>,
    directories: Vec<String>,
}

fn main() {
    let args = Args::parse();

    print!("{:?}\n", args);

    let application_types: Vec<ApplicationType> = vec![ApplicationType {
        name: String::from("Rust"),
        files: vec![
            String::from("Cargo.toml"),
            String::from("Cargo.lock"),
            String::from("src/*.rs"),
        ],
        directories: vec![String::from("target"), String::from("src")],
    }];

    get_dir(&args.path, &args.depth, &application_types);
}

fn get_dir(path: &String, depth: &usize, application_types: &Vec<ApplicationType>) {
    fn is_hidden(entry: &DirEntry) -> bool {
        entry
            .file_name()
            .to_str()
            .map(|s| s.starts_with("."))
            .unwrap_or(false)
    }

    let walker = WalkDir::new(path)
        .min_depth(1)
        .max_depth(depth.clone())
        .into_iter();
    for entry in walker.filter_entry(|e| !is_hidden(e)) {
        if let Ok(entry) = entry {
            //TODO: group by parent directory
            println!(
                "Parent dir: {}",
                get_parent_dir(&entry.path().display().to_string())
            );

            if &entry.path().is_dir() == &true {
                println!("{} is a directory\n", &entry.path().display());
            } else {
                println!("{} is a file\n", &entry.path().display());
            }
        }
    }
}

fn get_parent_dir(path: &str) -> &str {
    let path = Path::new(path);
    if let Some(parent) = path.parent() {
        parent.to_str().unwrap_or("")
    } else {
        ""
    }
}
