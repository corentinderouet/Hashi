class Utilitaire
    def Utilitaire.index(tab,element)
        c=-1
        for i in 0.. tab.length-1 do
            if (tab[i]==element)
                c=i
                break
            end
        end
        return c
    end
end
