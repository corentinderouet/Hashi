class Utilitaire
    def Utilitaire.index(tab,element)
        for i in 0.. tab.length-1 do
            if (tab[i]==element)
                break
            end
        end
        return i
    end
end
