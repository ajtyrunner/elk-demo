package cz.ratarusw.elkdemo.controller;

import cz.ratarusw.elkdemo.services.ELKDemoService;
import cz.ratarusw.elkdemo.services.RestService;
import org.json.simple.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

@RestController
@RequestMapping(value = "/api")
public class ELKDemoController {

    // Initializing instance of Logger for Controller
    private static final Logger log = LoggerFactory.getLogger(ELKDemoController.class);

    private final ELKDemoService service;

    private final RestService restService;

    public ELKDemoController(ELKDemoService service, RestService restService) {
        this.service = service;
        this.restService = restService;
    }

    @GetMapping(value = "/hello")
    public String helloWorld() {
        log.info("Hello endpoint call");
        String response = "Hello Jamf have gr8 day " + new Date();
        log.info("Response => {}",response);
        return response;
    }

    @GetMapping(value = "/apple-products")
    public JSONArray foodDetails() {
        log.info("Inside Apple Products Detail Function");
        return service.getAllAppleDetails();
    }
}