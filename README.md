# rails plugin: Schemaless

Rails generator for models with flex fields.

## Example

It uses `Item` as example model name.

### Generate

    ./script/generate schemaless Item
    rake db:migrate

### Usage

creation:

    item = Item.new
    item[:Name] = "Taro"
    item[:Place] = "Edo"
    item.save()
    p item[:Place]
    p item.keys

query:

    items = Item.by_name :Name
    items = Item.by_name_and_value :Name, "Taro"
    items = Item.by_names [:Name, :Place]
    items = Item.by_names_and_values :Name => "Taro", :Place => "Edo" 

## License

Copyright (c) 2009 bellbind, released under the MIT license
