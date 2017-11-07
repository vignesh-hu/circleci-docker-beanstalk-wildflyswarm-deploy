package com.easy.services;

import javax.enterprise.context.ApplicationScoped;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@ApplicationScoped
@Path("/")
public class ServiceEndpoint {

	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String alive() {
		return "I'm Alive!!!";
	}
}