/*
Copyright (c) 2013 Mairo Marcec <mario.marce42@googlmail.com>

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

public class TextFileViewer : Window {

    
    private TextView text_view;
    
    public TextFileViewer () {
        /** @TODO With UI or with elementary libgranit ??
        */
        this.title = "Source Lines of Code";
        this.window_position = WindowPosition.CENTER;
        set_default_size (800, 600);

        var toolbar = new Toolbar ();
        toolbar.get_style_context ().add_class (STYLE_CLASS_PRIMARY_TOOLBAR);

        var open_button = new ToolButton.from_stock (Stock.DIRECTORY);
        open_button.is_important = true;
        toolbar.add (open_button);
        open_button.clicked.connect (on_opendir_clicked);
        
      
        var about_button = new ToolButton.from_stock (Stock.ABOUT);
        about_button.is_important = true;
        toolbar.add (about_button);
        about_button.clicked.connect (on_about_clicked);
        
        var help_button = new ToolButton.from_stock (Stock.HELP);
        help_button.is_important = true;
        toolbar.add (help_button);
        help_button.clicked.connect (on_help_clicked);
        
        this.text_view = new TextView ();
        this.text_view.editable = false;
        this.text_view.cursor_visible = false;

        var scroll = new ScrolledWindow (null, null);
        scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        scroll.add (this.text_view);

        var vbox = new Box (Orientation.VERTICAL, 0);
        vbox.pack_start (toolbar, false, true, 0);
        vbox.pack_start (scroll, true, true, 0);
        add (vbox);
    }
    public void on_help_clicked()
    {
    /**
     *  @TODO Fenster mit "Help"-Text ausgaben
     */

    }
    
    private void on_about_clicked () {
        /** @DONE Logo PNG
        */ 
	      Valide.AboutDialog dialog;

        dialog = new Valide.AboutDialog ();
        dialog.run ();
        dialog.destroy ();
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
	string text =Project.project(filename);
    this.text_view.buffer.text =  text;
    }
    


    public static int main (string[] args) {
        Gtk.init (ref args);

        var window = new TextFileViewer ();
        window.destroy.connect (Gtk.main_quit);
        window.show_all ();

        Gtk.main ();
        return 0;
    }
}
