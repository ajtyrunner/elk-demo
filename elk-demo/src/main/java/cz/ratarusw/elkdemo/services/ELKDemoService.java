package cz.ratarusw.elkdemo.services;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.FileReader;
import java.io.IOException;

@Service
public class ELKDemoService {

    private static final Logger log = LoggerFactory.getLogger(ELKDemoService.class);

    public JSONArray getAllAppleDetails(){
        log.info("Fetching ALL apple product details...");
        JSONArray foodDetail = new JSONArray();
        try {
            JSONParser parser = new JSONParser();
            Object obj = parser.parse(new FileReader("example.json"));
            JSONObject jsonObject = (JSONObject) obj;
            foodDetail = (JSONArray) jsonObject.get("products");

        } catch (IOException | ParseException e) {
            log.error("Error occurred in reading JSON file");
            e.printStackTrace();
        }
        return foodDetail;
    }
}
