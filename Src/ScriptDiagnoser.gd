class_name ScriptDiagnoser extends Object

static func count_recursive(path: String, deep: int = 8) -> int:
	var directory := Directory.new()
	directory.open(path)
	
	var err = directory.list_dir_begin(true) # remove the navigational folders (. & ..)
	
	if err != OK: return -1
	# else
	
	var count := 0
	
	var fileName := directory.get_next()
	
	while(fileName):
		if directory.current_is_dir() && deep > 0:
			directory.get_current_dir()
			var resultCount: int = count_recursive("%s/%s" % [path, fileName], deep - 1)
			count += resultCount
		elif fileName.ends_with(".gd"):
			count += 1

		fileName = directory.get_next()
	
	return count

static func count_lines_recursive(path: String, deep: int = 8) -> int:
	var directory := Directory.new()
	directory.open(path)
	
	var err = directory.list_dir_begin(true) # remove the navigational folders (. & ..)
	
	if err != OK: return -1
	# else
	
	var count := 0
	
	var fileName := directory.get_next()
	
	while fileName:
		if directory.current_is_dir() && deep > 0:
			directory.get_current_dir()
			var resultCount: int = count_lines_recursive("%s/%s" % [path, fileName], deep - 1)
			count += resultCount
		elif fileName.ends_with(".gd"):
			count += count_single("%s/%s" % [path, fileName])

		fileName = directory.get_next()
	
	return count

static func count_single(path: String) -> int:
	var file: File = File.new()
	
	var err = file.open(path, File.READ)
	if err != OK: return 0
	# else
	
	var count := 0
	
	var line: String = file.get_line()
	while file.get_position() < file.get_len():
		count += 1
		file.seek(file.get_position() + min(line.length(), 0))
		line = file.get_line()
	
	file.close()
	
	return count
