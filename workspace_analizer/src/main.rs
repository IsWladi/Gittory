use clap::Parser;
use std::fs;

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    ///  define if the program should analyze the directory recursively
    #[arg(short = 'r', long)]
    recursive: bool,

    /// list of ignored directories and files
    #[arg(short = 'i', long)]
    ignore: Vec<String>,
}

#[derive(Debug)]
struct PathDetails {
    #[allow(dead_code)]
    path: String,
    #[allow(dead_code)]
    is_dir: bool,
    #[allow(dead_code)]
    sub_paths: Option<Vec<PathDetails>>,
}

impl PathDetails {
    fn new(path: String, is_dir: bool, sub_paths: Option<Vec<PathDetails>>) -> Self {
        PathDetails {
            path,
            is_dir,
            sub_paths,
        }
    }
}

fn main() {
    let args = Args::parse();

    print!("{:?}\n", args);

    let (dir_paths, files_paths) = get_path_details_from_dir("./", &args.recursive, &args.ignore);

    dbg!(&dir_paths);
    dbg!(&files_paths);
}

fn get_path_details_from_dir(
    dir_path: &str,
    recursive: &bool,
    ignore: &Vec<String>,
) -> (Vec<PathDetails>, Vec<PathDetails>) {
    let paths = fs::read_dir(dir_path).unwrap();

    let mut dir_paths: Vec<PathDetails> = Vec::new();
    let mut files_paths: Vec<PathDetails> = Vec::new();

    for path in paths {
        let unwrapped_path = path.as_ref().unwrap().path();

        if ignore.contains(&unwrapped_path.display().to_string()) {
            continue;
        }

        if unwrapped_path.is_dir() && recursive == &true {
            let (sub_dir_paths, mut sub_files_paths) =
                get_path_details_from_dir(&unwrapped_path.display().to_string(), recursive, ignore);

            dir_paths.push(PathDetails::new(
                unwrapped_path.display().to_string(),
                true,
                Some(sub_dir_paths),
            ));
            files_paths.append(&mut sub_files_paths);
        } else if unwrapped_path.is_dir() {
            dir_paths.push(PathDetails::new(
                unwrapped_path.display().to_string(),
                true,
                None,
            ));
        } else if unwrapped_path.is_file() {
            files_paths.push(PathDetails::new(
                unwrapped_path.display().to_string(),
                false,
                None,
            ));
        }
    }

    (dir_paths, files_paths)
}
