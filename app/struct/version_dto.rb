#
# To change this template, choose Tools | Templates
# and open the template in the editor.


class VersionDto < ActionWebService::Struct
  member :id, :int
  member :name, :string

  def VersionDto.create version
    VersionDto.new(
      :id => version.id,
      :name => version.name
    )
  end
end
