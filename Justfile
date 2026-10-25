# List available commands
default:
    @just --list

clean PACKAGE:
    @echo "Cleaning {{PACKAGE}}..."
    if [ -d pkgs/{{PACKAGE}}/ ]; then rm -rf pkgs/{{PACKAGE}}/src pkgs/{{PACKAGE}}/pkg pkgs/{{PACKAGE}}/*.pkg.tar.zst; fi 
    
build PACKAGE: (clean PACKAGE)
    @echo "Building {{PACKAGE}}..."
    cd pkgs/{{PACKAGE}} && makepkg -s -d --noconfirm --skippgpcheck 
