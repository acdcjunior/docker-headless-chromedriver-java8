# docker-chrome-headless-java8
Dockerfile for Chrome Headless (Debian) + Java 8

See: https://hub.docker.com/r/justinribeiro/chrome-headless/

This dockerfile adds chromedriver + oracle java 8 to the above image.


--
Issues:

> org.openqa.selenium.WebDriverException: unknown error: an X display is required for keycode conversions, consider using Xvfb

Chrome headless still has problems when using `sendKeys()` without an X display (which is what happens when we use this docker image).
https://bugs.chromium.org/p/chromedriver/issues/detail?id=1772

> Failed to move to new namespace: PID namespaces supported, Network namespace supported, but failed: errno = Operation not permitted

Apparently, chrome runs its renderer in a sandbox, which gives it less permissions than a regular process.

It [is said](https://github.com/jessfraz/dockerfiles/issues/17#issuecomment-99030326):
> Actually it's saying that it's running without the sandbox enabled. What that means is that the renderer (ie. the process that draws web pages), is running with more permissions than it usually would. That means a bug in the renderer is more likely to lead to your kernel being exploited than if you are running with the sandbox enabled.

This problem happens because chrome can't create a new namespace for the sandbox. So using `--cap-add=CAP_SYS_ADMIN` at `docker run` fixes it.



----

According to [ripper2hl](https://gist.github.com/addyosmani/5336747#gistcomment-2075042):

Very nice works perfectly with Selenium, no window size .
This run on ubuntu 17.04

    @BeforeTest
    public void setupTest() {
        ChromeDriverManager.getInstance().setup();
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless", "--disable-gpu");
        driver =  new ChromeDriver( options );
    }

ChromeDriverManager its a project of Boni Garcia
https://github.com/bonigarcia/webdrivermanager
