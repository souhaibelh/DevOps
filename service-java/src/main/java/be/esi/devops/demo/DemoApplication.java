package be.esi.devops.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		System.out.println("Testing je sais psa ce que je fais la lol");
		SpringApplication.run(DemoApplication.class, args);
	}

}