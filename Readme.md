Multiplatform lightweight Mame(Multiple Arcade Machine Emulator) cabinet frontend

It should work on any platform(Linux, OSX, windows)

# Features:
* Fast and effective UI
* Fully and Easy used via arcade controls
* Extensive and powerful ROM filtering by various lists / catgories
* Fully scaling UI: Meaning it should look fine both at 320x240(arcade screen) as well as 2000x900(LCD)

# Installation:
- Install Java 6 or newer
- Install [Fantom](http://www.fantom.org/)
- Install mamechose:  **fanr install -r http://repo.status302.com/fanr/ mameChose**
- Create a folder for MameChose (example mkdir /home/mem/mamechose/)
- Go in that folder and copy [mamechose.conf](https://bitbucket.org/tcolar/mamechose/raw/tip/mamechose.conf) into it
- **EDIT mamechose.conf and set mame.executable, romFolder, snapFolder correctly**

# Run:
Go in the mamechose folder and run:
> fan mameChose -c mameChose.conf

# Screenshots:

See Full screenshots Here: [https://bitbucket.org/tcolar/mamechose/src/tip/shots/](https://bitbucket.org/tcolar/mamechose/tip/shots/)

![Screenshot](https://bitbucket.org/tcolar/mamechose/raw/tip/shots/categories.png)

