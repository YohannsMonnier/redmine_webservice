#****************************************************
#                                                   *
# Redmine Webservice - Yohann Monnier - Internethic  *
#													*
#****************************************************r.
 
class QueryStringDecoder < ActionController::UrlEncodedPairParser
  def initialize(query_string)
    super(find_pairs(query_string))
#    @result = to_symbols(@result)
  end
  
  def find_pairs(query_string)
    return {} if query_string.blank?

    pairs = query_string.split('&').collect do |chunk|
      next if chunk.empty?
      key, value = chunk.split('=', 2)
      next if key.empty?
      value = value.nil? ? nil : CGI.unescape(value)
      [ CGI.unescape(key), value ]
    end.compact
    
    return pairs
  end
  
  def to_symbols hash
    hash.each {|key, value|
      hash.delete(key)
      case value
        when String
          hash.store(key.to_sym, value)
        when Hash
          hash.store(key.to_sym, to_symbols(value))
        when Array
          value.each_index{|x|
            case value[x]
              when String
                value[x]=value[x].to_sym
            end
          }
          hash.store(key.to_sym, value)
          
      end
    }
    return hash
    
  end
  
  def project
    @project ||= Project.find(@result['project_id'])
    rescue
      nil
  end
  
  def query
    @query ||= build_query
  end
  
  def build_query
    query = Query.new(:name => "_")
    query.project = @project
    if @result['fields'] and @result['fields'].is_a? Array
      @result['fields'].each do |field|
        query.add_filter(field, @result['operators'][field], @result['values'][field])
      end
    end
    return query
  end
  
end

