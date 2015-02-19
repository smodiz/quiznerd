module TextAreaHelper

  # Calculate the number of rows a text area should have in order
  # to display all the existing text
  def text_area_rows(content, field_width = 50, min=2)
    rows = [min]
    if content.present?
        rows << calculate_by_length(content.length, field_width) + 
          number_of_newlines(content)
    end
    rows.max
  end

  private

  def number_of_newlines(text)
    newlines = text.split(/\r\n/).length
  end

  def calculate_by_length(length, width)
    (length.to_f/width).ceil + 1
  end
end