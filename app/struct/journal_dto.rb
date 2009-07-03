# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class JournalDto < ActionWebService::Struct
#          <id xsi:type="xsd:int">4</id>
#          <journalized_id xsi:type="xsd:int">3</journalized_id>
#          <journalized_type xsi:type="xsd:string">Issue</journalized_type>
#          <user_id xsi:type="xsd:int">4</user_id>
#          <notes xsi:type="xsd:string">das ist der zweite kommentar</notes>
#          <created_on xsi:type="xsd:dateTime">2008-05-29T20:25:38+02:00</created_on>

  member :id, :int
  member :issue_id, :int
  member :author_id, :int
  member :author_name, :string
  member :notes, :string
  member :created_on, :datetime
  member :editable_by_user, :boolean
  
  def JournalDto.create journal
    if (journal.notes=='')
      return nil
    end
    JournalDto.new(
      :id => journal.id,
      :issue_id => journal.journalized_id,
      :author_id => journal.user_id,
      :author_name => journal.user.name,
      :notes => journal.notes,
      :created_on => journal.created_on,
      :editable_by_user => journal.editable_by?(User.current)
    )
  end

end
