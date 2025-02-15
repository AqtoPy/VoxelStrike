class_name NameValidator

static func is_valid(name: String) -> bool:
    var regex = RegEx.new()
    regex.compile("^[\\w]{3,16}$")
    return regex.search(name) != null

static func is_reserved(name: String) -> bool:
    return name in ["AutoAuto", "Admin", "Server"]
