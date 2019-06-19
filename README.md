![Emerald Gaming Logo](https://i.imgur.com/0P2v1NZ.png)
# INTRODUCTION
![Maintained](https://img.shields.io/maintenance/yes/2019.svg)
![License](https://img.shields.io/github/license/ImSkully/emeraldgamingmta.svg)
![Version](https://img.shields.io/github/release-pre/ImSkully/emeraldgamingmta.svg)
![Size](https://img.shields.io/github/repo-size/ImSkully/emeraldgamingmta.svg)

Welcome to the **Emerald Gaming GitHub** page. Here you'll find the base for all changes, events and whatnot regarding the gamemode.

***
## Useful Links
* **[Issues](https://github.com/ImSkully/emeraldgamingmta/issues)**
* **[To-Do List](https://github.com/ImSkully/emeraldgamingmta/projects/1)**
* **[Wiki Page](https://github.com/ImSkully/emeraldgamingmta/wiki)**
* **[Pulse Results](https://github.com/ImSkully/emeraldgamingmta/graphs/commit-activity)**
* **[Development Branch](https://github.com/ImSkully/emeraldgamingmta/tree/development)**


***

**Emerald Gaming** is an [Multi Theft Auto: San Andreas](https://mtasa.com/) *roleplay server* initially created back on the **2nd of July, 2016**. It was started as a personal development project to better improve scripting and LUA programming skills. Having grown overtime, the gamemode was publicly released on the **31st of March, 2018** under continuous development, however due to lacking of availability and commitment to the project, the official Emerald Gaming community was discontinued a year later, on the **31st of March, 2019.**

## Primary Contributors
 * [Zil](https://github.com/ItsZil) - Emerald Gaming Development Team
 * [Skully](https://github.com/ImSkully) - Emerald Gaming Development Team

***
## Installation & Setup
1. Download and extract the latest [MTA Server](https://nightly.mtasa.com/) build.
2. Download the latest [server resources release](https://github.com/ImSkully/emeraldgamingmta/releases) and [SQL database](https://github.com/ImSkully/emeraldgamingmta/releases/download/v0.4.0/emerald.sql).
3. Extract all resources into your MTA server `resources` directory.
4. Import the [`emerald.sql`](https://github.com/ImSkully/emeraldgamingmta/releases/download/v0.4.0/emerald.sql) file into your MySQL server, this can take a few minutes.
	*  For phpMyAdmin servers, go to the **Import** tab and select the file from there.
5. Adjust the [`s_connection.lua`](https://github.com/ImSkully/emeraldgamingmta/blob/master/mysql/s_connection.lua) file in the resource **mysql** to your own database credentials.
6. Download the [`mtaserver.conf`](https://github.com/ImSkully/emeraldgamingmta/releases/download/v0.4.0/mtaserver.conf) file and replace your original one.
7. Start the server and monitor the console for any errors from specific resources.
8. Connect to the server and register a new account, you will be prompted to visit the website to complete an entry test, to bypass this, go to your database and into the `accounts` table, find your account and change the `appstate` to `1`.
9. Login to the server.

### Getting Management & Developer Access

In the `accounts` table of your database, find your account row and adjust the following:
 * Adjust `rank` to `6` for Lead Manager.
 * Adjust `developer` to `2` for Lead Developer.

__Ensure you are not on the server when doing this!__ Your changes will be reverted otherwise and will not apply. Once you change the above values in the database, log into the server as normal and you will be given ACL access as well as the Lead Manager rank, with this you can simply use `/staffs` to adjust your auxiliary staff team states.
***
### Licensing

Emerald Gaming, Emerald Gaming Roleplay and all associated programs, files, logos, attributes, content are a copyright of the Emerald Gaming Development Team hereby recognized as the primary contributors to the repository.

The Emerald Gaming gamemode is released under the GNU General Public License v3.0, permissions of this strong copyleft license are conditioned on making available complete source code of licensed works and modifications, which include larger works using a licensed work, under the same license. Copyright and license notices must be preserved. Contributors provide an express grant of patent rights.

You may not impose any further restrictions on the exercise of the rights granted or affirmed under this License.  For example, you may not impose a license fee, royalty, or other charge for exercise of rights granted under this License, and you may not initiate litigation (including a cross-claim or counterclaim in a lawsuit) alleging that any patent claim is infringed by making, using, selling, offering for sale, or importing the Program or any portion of it.
