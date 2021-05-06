/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Main;

import javax.annotation.Resource;
import javax.ejb.ActivationConfigProperty;
import javax.ejb.MessageDriven;
import javax.jms.ConnectionFactory;
import javax.jms.MapMessage;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.Topic;

/**
 *
 * @author gabriel
 */
@MessageDriven(activationConfig = {
    @ActivationConfigProperty(propertyName = "clientId", propertyValue = "jms/topic")
    ,
        @ActivationConfigProperty(propertyName = "destinationLookup", propertyValue = "jms/topic")
    ,
        @ActivationConfigProperty(propertyName = "subscriptionDurability", propertyValue = "Durable")
    ,
        @ActivationConfigProperty(propertyName = "subscriptionName", propertyValue = "jms/topic")
    ,
        @ActivationConfigProperty(propertyName = "destinationType", propertyValue = "javax.jms.Topic")
})
public class NewMessageBean implements MessageListener {
    @Resource(mappedName="jms/TopicFactory") private static ConnectionFactory topicFactory;
    @Resource(mappedName="jms/topic") private static Topic topic;
    
    public NewMessageBean() {
    }
    
    @Override
    public void onMessage(Message message) {
         MapMessage msg = null;
        try {

        msg = (MapMessage)message;
        System.out.println("—————————————-");
        System.out.println(msg.getString("lastname"));
        System.out.println(msg.getString("firstname"));
        System.out.println(msg.getString("id"));
        System.out.println("—————————————-");
        }
        catch (Exception e) {
            }
    }
    
}
