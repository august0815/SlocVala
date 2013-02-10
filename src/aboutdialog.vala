/* aboutdialog.vala
 *
 * Copyright (C) 2008-2009  Nicolas Joseph
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author:
 * 	Nicolas Joseph <nicolas.joseph@valaide.org>
 */

/**
 * The about dialog box 
 */
public class Valide.AboutDialog : Gtk.AboutDialog
{
  private const string _copyright = "Marcec Mario ";//Config.COPYRIGHT;
  private const string _program_name = "Vala SLOC";//Config.PACKAGE_NAME;
  private const string _version = "0.0.1pre";//Config.VERSION;
  private const string _website = "localhost";

  private void activate_link_func (Gtk.AboutDialog self, string link)
  {
    try
    {
      AppInfo.launch_default_for_uri (link, null);
    }
    catch (Error e)
    {
      warning (e.message);
    }
  }

  construct
  {
    try
    {
      this.logo = new Gdk.Pixbuf.from_file (Path.build_filename (".", "logo.png"));
    }
    catch (Error e)
    {
      debug (e.message);
    }

    try
    {
      string contents;

      FileUtils.get_contents (Path.build_filename (".", "AUTHORS"),
                              out contents);
      this.authors = contents.split ("\n");
    }
    catch (Error e)
    {
      debug (e.message);
    }

    this.license = """This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.""";

    this.program_name = _program_name;
    this.version = _version;
    this.website = _website;
    this.copyright = _copyright;
   // this.set_url_hook (activate_link_func);
  }
}

