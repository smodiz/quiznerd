module ApplicationHelper
	def full_title(page_title)
	  title = "Quiz Nerd"
		title += " | #{page_title}" unless page_title.empty? 
		title		
	end
end
