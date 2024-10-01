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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_get_parent_dir() {
        let path = String::from("src/main.rs");
        assert_eq!(get_parent_dir(&path), "src");
    }

    #[test]
    fn test_get_resource_name() {
        let path = String::from("src/main.rs");
        assert_eq!(get_resource_name(&path), "main.rs");
    }
}
