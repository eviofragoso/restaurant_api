passo a passo desafio

1 - utilizei docker run para gerar o projeto, pois não tenho ruby instalado nativo
2 - rodei o comando rails new --api --devcontainer --skip-kamal restaurant_menu
3 - Adicionei Rspec porque é o framework de test citado na descrição da vaga
4 - rails g scaffold menu availability:integer name:string description:text signed_chef:string day_period:integer --test-framework rspec --api
5 - rails g scaffold menu_item menu:belongs_to description:text lact_free:boolean gluten_free:boolean name:string --test-framework rspec --api
6 - Fixed pending tests for menu, adding valid and invalid attributes, created a test case for each presence validation individually
7 - comecei a fazer commits com passos mais individuais, para a histório de desenvolvimento ficar mais clara
8 - The scaffold command used automatically creates the routes for the created resources, adding resource directive in routes
9 - Added Factory bot to test more efficently
10 - rails generate factory_bot:model menu availability:integer name:string description:text signed_chef:string day_period:integer
11 - rails generate factory_bot:model menu_item menu:belongs_to description:text lact_free:boolean gluten_free:boolean name:string
12 - Added model unit tests to cover validation behaviours
13 - Finished rspec config
14 - [lvl2] rails g scaffold restaurant name:string address:text --test-framework rspec --api
15 - [lvl2] Added new associations to menu and restaurant
16 - [lvl2] Fixed tests with the added restaurant association
17 - [lvl2] Handled the pending restaurant tests and added restaurant validation tests
18 - [lvl2] Added restaurant validation test in menu tests
19 - [lvl2] Added Uniqueness validation test in menu item tests
20 - [lvl2] rails g model menu_menu_item menu:belongs_to menu_item:belongs_to
21 - [lvl2] Added migration to handle change in the menu items association, now belonging to restaurant
22 - [lvl2] Added data migrating in the migration, so there is no orphaned menu items when changing the belongs_to association
23 - [lvl2] Adapted tests to the new association structure
24 - [lvl2] Added tests to validate the behaviour of menu having multiple menu items and menu items can be on multiple menus
25 - [lvl2] Added Faker to help generating unique names for tests and to genererate test data more efficiently in general
26 - [lvl2] Added filtering in menu and menu item so the data can be acessed based on its associations. I preferred it over nested routes beacause it's an API an its easier to maintain and to comply to multiple use cases.
27 - [lvl2] Added use cases to validate the filtering
28 - [lvl3] Since the json is an array os restaurants, added an import endpoint in the restaurant controller
29 - [lvl3] Created a import service, using a PORO class
30 - [lvl3] Added price to the menu menu item association
31 - [lvl3] Added endpoint checks for file existence and format
32 - [lvl3] Changed validations to adapt to json data
