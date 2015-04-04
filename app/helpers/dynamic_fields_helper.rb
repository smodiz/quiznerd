# Creates a link to dynamically add fields for a nested
# model on a form. This assumes the partial is in the
# parent view folder.
module DynamicFieldsHelper
  def link_to_add_fields(name, form, association)
    new_obj = form.object.send(association).klass.new
    fields = render_fields(association, form, new_obj)
    link_to(name,
            '#',
            class: 'add_fields',
            data: { id: new_obj.object_id, fields: fields.gsub('\n', '') })
  end

  private

  def render_fields(association, form, new_obj)
    dir = form.object.class.name.downcase.pluralize
    partial = "#{association.to_s.singularize}_fields"
    id = new_obj.object_id
    form.simple_fields_for(association, new_obj, child_index: id) do |builder|
      render "#{dir}/#{partial}", f: builder
    end
  end
end
