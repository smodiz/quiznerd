 module DynamicFieldsHelper 

  # Creates a link to dynamically add fields for a nested 
  # model on a form. This assumes the partial is in the 
  # parent view folder.
  def link_to_add_fields(name, form, association)
    new_object  = form.object.send(association).klass.new
    id          = new_object.object_id
    dir         = form.object.class.name.downcase.pluralize
    partial     = "#{association.to_s.singularize}_fields"

    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render "#{dir}/#{partial}", f: builder
    end

    link_to(name, 
            '#', 
            class: "add_fields", 
            data: {id: id, fields: fields.gsub("\n", "")})
  end

end

