name="sars_cov_2"
disease="covid19"

print("The name of the virus is", name)
print("The name of the virus is {}".format(name))

# Replace the varibale everywhere where you want using {}
#e.g 
print("{} is the name of the virus.".format(name))
print("And this is found in a {} disease".format(disease))

print("The name of the virus is {} and it causes {}".format(name,disease))
print(f"The name of the virus is {name} and it causes {disease}") # f function it wrok on higher version of python above 3.6

# Concatination
print("The name of virus is" + " " + name)
