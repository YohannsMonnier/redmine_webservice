# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class MemberDto < ActionWebService::Struct
  member :id, :int
  member :name, :string
  member :assignable, :bool
  
  def MemberDto.create member
    MemberDto.new(
      :id => member.user.id,
      :name => member.user.name,
      :assignable => member.role.assignable
    )
  end
end
