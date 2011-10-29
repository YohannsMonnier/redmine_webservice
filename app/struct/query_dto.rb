#
# To change this template, choose Tools | Templates
# and open the template in the editor.


class QueryDto < ActionWebService::Struct
  member :id, :int
  member :name, :string

  def QueryDto.create query
    QueryDto.new(
      :id => query.id,
      :name => query.name
    )
  end
end
