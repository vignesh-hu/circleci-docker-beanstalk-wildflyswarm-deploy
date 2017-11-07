package com.easy;

import org.wildfly.swarm.Swarm;

public class Main {

    public static void main(String[] args) throws Exception {
        System.out.println("Running " + Main.class.getCanonicalName() + ".main");
        Swarm swarm = new Swarm();
        swarm.start().deploy();
    }
}