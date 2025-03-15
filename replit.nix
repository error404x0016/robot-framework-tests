{ pkgs }: {
  deps = [
    pkgs.python313  # Use Python 3.13
    pkgs.chromium  # If needed for Selenium
    pkgs.chromedriver  # If needed for Selenium
  ];
}