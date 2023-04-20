package com.bigdata.docker.spring;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
public class HelloController {
    Logger logger = LoggerFactory.getLogger(HelloController.class);

    private static int counter = 1;
    int minValue = 1;
    int maxValue = 10;

    @Value("${app.version}")
    private String appVersion;

    @GetMapping("/")
    public ModelAndView welcome() {
        String hostname = System.getenv("HOSTNAME");
        logger.info(hostname);
        logger.info("Welcome page accessed " + counter++ + " times");
        String image = (appVersion.isEmpty() || appVersion.equalsIgnoreCase("v1")) ? "Welcome1.gif" : "Welcome2.gif";
        ModelAndView modelAndView = new ModelAndView("welcome");
        modelAndView.addObject("image", image);
        modelAndView.addObject("server", hostname);
        return modelAndView;
    }
}
