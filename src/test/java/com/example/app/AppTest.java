package com.example.app;

import static org.junit.jupiter.api.Assertions.assertEquals;
import org.junit.jupiter.api.Test;

public class AppTest {

    @Test
    public void shouldReturnHelloWorld() {
        assertEquals("Hello, Claudio Souza!", App.hello());
    }
}
