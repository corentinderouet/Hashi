

class Lien

	attr_reader:case1
	attr_reader:case2
	attr_accessor:hypothese


	private_class_method:new

	def initialize(case1,case2,hypothese)

		@case1=case1
		@case2=case2
		@hypothese=hypothese
	end

	def Lien.creer(case1,case2,hypothese)
		new(case1,case2,hypothese)
	end

	def afficher_lien()
		puts('(' "#{@case1.etiquetteCase}"','"#{@case2.etiquetteCase}" ')')
	end



end
