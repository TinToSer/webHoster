//JMS
//Developed by https://github.com/TinToSer
module main

import os
import os.cmdline
import vweb

struct App {
	vweb.Context
}

fn main() {
	
	mut port_number := '10101'
	mut folders := 'static'
	mut index := 'index.html'
	if os.args.len < 3 {
		println('Usage: webHosting.exe -p <Listening Port> -host <Comma separated folderslist> -index <index.html>\n')
		println('Using default Listening Port:${port_number} and folder:${folders} with default ${index} in parent folder\n\n')
	} else {
		if "-p" in os.args{
			port_number = cmdline.option(os.args, '-p', port_number)
		}
		if "-host" in os.args{
			folders = cmdline.option(os.args, '-host', folders)
		}
		if "-index" in os.args{
			index = cmdline.option(os.args, '-index', index)
		}
		
	}

	if port_number.int() > 65536 {
		eprintln('${port_number} must be less than 65536')
		exit(1)
	}
	mut app := &App{}
    for each_folder in folders.split(","){
		if os.is_dir(each_folder){
			app.handle_static(each_folder, true)
		}
	}
	if os.is_file(index){
		app.serve_static('/',index)
	}
	vweb.run(app, port_number.int())
}

