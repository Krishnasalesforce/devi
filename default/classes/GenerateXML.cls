public class GenerateXML {
	public static void StreamExample()
{
    XmlStreamWriter writer = new XmlStreamWriter();
    
    writer.writeStartDocument('utf-8', '1.0');        
    writer.writeStartElement(null, 'response', null);
    
    list<account> accountlist = [ 
        select  id, name, 

                (select id, name, email from Contacts) 
          from  Account LIMIT 1
    ];
          
    for (Account eachAccount : accountList) {
        writer.writeStartElement(null, 'Account', null);
        writer.writeAttribute(null, null, 'id', eachAccount.Id);
        writer.writeAttribute(null, null, 'name', eachAccount.Name);        

        for (Contact eachContact : eachAccount.Contacts) {
            writer.writeStartElement(null, 'Contact', null);
            
            writer.writeAttribute(null, null, 'id', eachContact.Id);
            writer.writeAttribute(null, null, 'name', eachContact.Name);
            writer.writeAttribute(null, null, 'email', eachContact.Email);
            
            writer.writeEndElement();
        }
        
        writer.writeEndElement();
    }
    
    writer.writeEndElement();
    
    system.debug(writer.getXmlString());
    
    writer.close();            
}
    
    public static void xmlss() {
    	XmlStreamWriter writer = new XmlStreamWriter();   

    writer.writeStartDocument('utf-8', '1.0');       
writer.writeCharacters('csvField_FromApex');
 

    writer.writeStartElement(null, 'object', null);

    writer.writeStartElement(null, 'field6', null);

    writer.writeCharacters('AccountField_FromApex');

    writer.writeEndElement();  

 

    writer.writeStartElement(null, 'csv6', null);

    writer.writeCharacters('csvField_FromApex');

    writer.writeEndElement(); 

 

    writer.writeEndElement();   

    system.debug('Written xml file ' +writer.getXmlString());   

    writer.close();

 

    
    }
}