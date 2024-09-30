use std::path::Path;
pub fn get_parent_dir(path: &String) -> String {
    let path = Path::new(&path);
    if let Some(parent) = path.parent() {
        parent.to_str().unwrap_or("").to_string()
    } else {
        "".to_string()
    }
}

pub fn get_resource_name(path: &String) -> String {
    let path = Path::new(&path);
    path.file_name().unwrap().to_str().unwrap_or("").to_string()
}
