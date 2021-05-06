package Main;


import javax.annotation.Resource;
import javax.jms.Connection;
import javax.jms.ConnectionFactory;
import javax.jms.MapMessage;
import javax.jms.MessageProducer;
import javax.jms.Session;
import javax.jms.Topic;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author gabriel
 */
public class Main {
    
    @Resource(mappedName="jms/TopicFactory") private static ConnectionFactory topicFactory;
    @Resource(mappedName="jms/topic") private static Topic topic;
    public static void main(String[] args) {
        
       Connection topicConnection = null;
       Session session = null;
       MapMessage message = null;
       MessageProducer producer = null;

    try {
        topicConnection = topicFactory.createConnection();
        session = topicConnection.createSession(false, Session.AUTO_ACKNOWLEDGE);
        producer = session.createProducer(topic);
        message = session.createMapMessage();

        message.setString("lastname", "Smith");
        message.setString("firstname", "John");
        message.setString("id", "0100");

        producer.send(message);
    }
    catch (Exception e) {
        e.printStackTrace();
        }
    }
}
