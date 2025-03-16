{ pkgs }: {
  deps = [
    pkgs.nano
    pkgs.python311Packages.robotframework-seleniumlibrary
    pkgs.python311Packages.robotframework-selenium2library
    pkgs.python312Packages.selenium  # Use Python 3.13  # If needed for Selenium  # If needed for Selenium
  ];
}