# SpringSH

## Generate Model

**Usage:** sh generate-model.sh [-m MODEL] [p PROJECT_PATH]

Generate the model related objects in the Spring project

&nbsp;&nbsp;**-m [MODEL]** &nbsp;&nbsp;Specify the model name. For example, by specifing model as User, script will create UserController, UserFacade, etc.

&nbsp;&nbsp;**-p [PROJECT_PATH]** &nbsp;&nbsp;Specify the Spring project path, including the package.


### Templates Folder

templates folder just holds the prepared templates, which then is parsed by the **template-parsers.sh** script. The variables in the templates are declared as {SOME_VARIABLE}, which then is parsed and replaced by regex.

### Template Parser Script

The **template-parsers.sh** script declares the functions, which are required for the **generate-model.sh** script. It simply exports the parser functions.

Inside the functions, templates located in **templates folder** are parsed.
