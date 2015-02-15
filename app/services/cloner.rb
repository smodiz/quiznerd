class Cloner 

  def self.clone(obj)
    new_obj = obj.class.new.from_xml(obj.to_xml except: [ :id, :created_at, :updated_at])
  end

end
