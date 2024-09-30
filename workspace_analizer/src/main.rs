mod util;
mod workspace_recognizer;

use workspace_recognizer::{get_recognized_applications, ApplicationType, RecognizedApplication};

use clap::Parser;

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

fn main() {
    let args = Args::parse();

    print!("{:?}\n", args);

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
            name: String::from("Qmk Keyboard"),
            resources: vec![String::from("keymap.c")],
        },
    ];

    dbg!(&application_types);

    let recognized_applications: Vec<RecognizedApplication> =
        get_recognized_applications(&args.path, &args.depth, &application_types);

    dbg!(recognized_applications);
}
