public class cls_VFAttachFile 
{
    public PageReference save() 
    {
        return null;
    }

    public String docBlob { get; set; }
    public string filename {get; set; }
    public String getAttachment() 
    {
        return null;
    }

 Contact contact;

    public Contact getContact() 
    {
    if(contact == null) contact = new Contact();
    return contact;
    }    
    
  public PageReference SaveFile() 
  {   
        contact.lastname = filename;
        insert contact;
        Id id = System.currentPageReference().getParameters().get('id'); 
        Attachment attachment = new Attachment(); 
        PageReference Pg = new PageReference('/apex/krishna');        
        Blob docBlob = Pg.getContent();
        attachment.Body = docBlob;
        attachment.Name = filename;
        attachment.ParentId = contact.id;
        insert attachment;
        return null;
    }
}