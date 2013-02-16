/*
Copyright (c) 2013 Mario Marcec <mario.marce42@googlmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal 
in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/
using Gtk;
using Gee;

	class ProjektWindow : Gtk.Window
	{
	public Gtk.Box vbox;	
    private TextView text_view;
	public string text="";	
	private bool welcom=true;
	public ArrayList<string> list;
	public SlocV projekt;
	public int filecount =0 ;
	
		Granite.Widgets.Welcome welcome;
		
		// Toolbar elements
		Gtk.Toolbar toolbar = new Gtk.Toolbar();
		Gtk.Menu menu;
		Granite.Widgets.AppMenu appMenu;

		
		// Preferences

		/**
		 * Creates a  window.
		 */
		public ProjektWindow (string? path = "", Granite.Application app) {
				projekt=new SlocV();
				list = new ArrayList<string> ();
				list.add (".vala");
				//list.add (".c");
				//list.add (".cpp");
				//list.add (".h");
				//list.add ("Makefile");
				//list.add ("cmake");
				list.add ("wscript");
			set_default_size (800, 600);
			menu = new Gtk.Menu();
			welcome = new Granite.Widgets.Welcome("Count sorce code of lines in VALA-codefiles\n  Start: select an directory .", "Open ...");
			
			// Menu
			menu.show_all();
		//var open_menuitem = new Gtk.MenuItem.with_label("Open");
			
		//	menu.append(open_menuitem);

		//	menu.append(new Gtk.SeparatorMenuItem());
						
			// AppMenu

			appMenu = app.create_appmenu(menu);
			var appMenu_item = new Gtk.ToolItem();
			appMenu_item.add(appMenu);
			
			// Toolbar
			toolbar.get_style_context().add_class ("primary-toolbar");
			ToolButton menue_open =new ToolButton(new Image.from_stock(Stock.OPEN,IconSize.BUTTON),"");
			toolbar.insert(appMenu_item, -1);
			toolbar.insert(menue_open, -1);
			// Text
		    this.text_view = new TextView ();
			this.text_view.editable = false;
			this.text_view.cursor_visible = false;

			// Basic UI
			vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			add (vbox);
			vbox.pack_start (toolbar, false, false);
			vbox.pack_start (welcome, true, true);
			vbox.show_all();
			toolbar.show_all();

			welcome.append(Gtk.Stock.OPEN, "Open ", "Open ....");
			welcome.set_sensitive(true); 
			welcome.show_all();
			// Connections
			welcome.activated.connect(on_welcome_activated);
			menue_open.clicked.connect (on_opendir_clicked);
		}

		/**
		 * Called when a button of the welcome panel activated.
		 */
		private void on_welcome_activated(int index) {
			if (index == 0)
			{ on_opendir_clicked(); }
		}
		private void on_opendir_clicked () {
        var file_chooser = new FileChooserDialog ("Sloc DIR", this,
                                      FileChooserAction.SELECT_FOLDER,
                                      Stock.CANCEL, ResponseType.CANCEL,
                                      Stock.OPEN, ResponseType.ACCEPT);
        if (file_chooser.run () == ResponseType.ACCEPT) {
            open_dir (file_chooser.get_filename ());
        }
        file_chooser.destroy ();
		}

		private void open_dir (string filename) {
		
		File file = File.new_for_path(filename);

			list_children(file, new Cancellable (),filename+"/");
			if (welcom){
			welcom=false;
			vbox.remove(welcome);
			var scroll = new ScrolledWindow (null, null);
			scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
			scroll.add (this.text_view);
			vbox.pack_start (scroll,true,true);
			scroll.show_all();}
			report();
		    
		

		}
	private void list_children (File file, Cancellable? cancellable = null,string filename ) throws Error {
		FileEnumerator enumerator = file.enumerate_children ("standard::*",FileQueryInfoFlags.NOFOLLOW_SYMLINKS,cancellable);
		int gesamtsloc=0;
        
		FileInfo info = null;
		while (cancellable.is_cancelled () == false && ((info = enumerator.next_file (cancellable)) != null)) {
			if ((info.get_file_type () == FileType.DIRECTORY)&&(!(info.get_is_hidden ()))) {
				File subdir = file.resolve_relative_path (info.get_name ());
				string filenam=filename+info.get_name()+"/";
				list_children (subdir,  cancellable,filenam);
			} else {
				if(!(info.get_is_hidden ())){
					foreach (string i in list) {
						if (i in info.get_name()){
							projekt.addsloc(info.get_name (),filename+"/");
							gesamtsloc=projekt.gesamtsloc;
							filecount++;
								}
							}
						}
				}
			}
			
	if (cancellable.is_cancelled ()) {
		throw new IOError.CANCELLED ("Operation was cancelled");
	}
}


	public void report(){
			text=projekt.getText();
			this.text_view.buffer.text =  text;
			projekt.neusloc();}
//		private void close() {
//			hide();
//			Gtk.main_quit();
//		}		
	}

