module CheatsheetsHelper
  def new_cheatsheet_button
    link_to(
      "<i class='#{Icon::NEW}'></i> New Cheatsheet".html_safe,
      new_cheatsheet_path,
      class: 'btn btn-primary pull-right btn-sm')
  end
end
