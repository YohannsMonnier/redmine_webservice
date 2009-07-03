# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 
#          <id xsi:type="xsd:int">1</id>
#          <container_id xsi:type="xsd:int">6</container_id>
#          <container_type xsi:type="xsd:string">Issue</container_type>
#          <filename xsi:type="xsd:string">e1000_dump.txt</filename>
#          <disk_filename xsi:type="xsd:string">081021202040_e1000_dump.txt</disk_filename>
#          <filesize xsi:type="xsd:int">14622</filesize>
#          <content_type xsi:type="xsd:string">text/plain</content_type>
#          <digest xsi:type="xsd:string">7a70f9b679bbeb6a40047e80ec1cc15c</digest>
#          <downloads xsi:type="xsd:int">0</downloads>
#          <author_id xsi:type="xsd:int">4</author_id>
#          <created_on xsi:type="xsd:dateTime">2008-10-21T20:20:40+02:00</created_on>
#          <description xsi:type="xsd:string">backup firmware e1000</description>

class AttachmentDto < ActionWebService::Struct

  member :id, :int
  member :author_id, :int
  member :author_name, :string
  member :created_on, :datetime
  member :filename, :string
  member :filesize, :int
  member :digest, :string
  member :content_type, :string
  member :description, :string
  
  def AttachmentDto.create attachment
    AttachmentDto.new(
      :id => attachment.id,
      :author_id => attachment.author_id,
      :author_name => attachment.author.name,
      :created_on => attachment.created_on,
      :filename => attachment.filename,
      :filesize => attachment.filesize,
      :digest => attachment.digest,
      :content_type => attachment.content_type,
      :description => attachment.description
    )
  end

end
