class 'BuyMenu'
class 'BuyMenuEntry'

function BuyMenuEntry:__init( model_id, price, entry_type )
    self.model_id = model_id
    self.price = price
    self.entry_type = entry_type
end

function BuyMenuEntry:GetPrice()
    return self.price
end

function BuyMenuEntry:GetModelId()
    return self.model_id
end

function BuyMenuEntry:GetListboxItem()
    return self.listbox_item
end

function BuyMenuEntry:SetListboxItem( item )
    self.listbox_item = item
end

class 'VehicleBuyMenuEntry' (BuyMenuEntry)

function VehicleBuyMenuEntry:__init( model_id, price )
    BuyMenuEntry.__init( self, model_id, price, 1 )
end

function VehicleBuyMenuEntry:GetName()
    return Vehicle.GetNameByModelId( self.model_id )
end

class 'WeaponBuyMenuEntry' (BuyMenuEntry)

function WeaponBuyMenuEntry:__init( model_id, price, slot, name )
    BuyMenuEntry.__init( self, model_id, price, 2 )
    self.slot = slot
    self.name = name
end

function WeaponBuyMenuEntry:GetSlot()
    return self.slot
end

function WeaponBuyMenuEntry:GetName()
    return self.name
end

class 'ModelBuyMenuEntry' (BuyMenuEntry)

function ModelBuyMenuEntry:__init( model_id, price, name )
    BuyMenuEntry.__init( self, model_id, price, 2 )
    self.name = name
end

function ModelBuyMenuEntry:GetName()
    return self.name
end

function BuyMenu:CreateItems()
    self.types = {
        ["Vehicle"] = 1,
        ["Weapon"] = 2,
        ["Model"] = 3
    }

    self.id_types = {}

    for k, v in pairs(self.types) do
        self.id_types[v] = k
    end
    self.items = {
        [self.types.Vehicle] = {
            { "Land", "Air", "Sea" },
            ["Land"] = {
                VehicleBuyMenuEntry( 29, 0 ),
                VehicleBuyMenuEntry( 11, 0 ),
                VehicleBuyMenuEntry( 13, 0 ),
				VehicleBuyMenuEntry( 21, 25 ),
				VehicleBuyMenuEntry( 43, 25 ),
				VehicleBuyMenuEntry( 76, 25 ),
				VehicleBuyMenuEntry( 87, 25),
                VehicleBuyMenuEntry( 89, 25 ),
				VehicleBuyMenuEntry( 2, 50 ),
			    VehicleBuyMenuEntry( 35, 50 ),
				VehicleBuyMenuEntry( 46, 50 ),
                VehicleBuyMenuEntry( 18, 100 ),
				VehicleBuyMenuEntry( 72, 100 ),
			    VehicleBuyMenuEntry( 77, 200 ),
			    VehicleBuyMenuEntry( 56, 300 ),
               -- VehicleBuyMenuEntry( 22, 200 ),
              

              
               -- VehicleBuyMenuEntry( 54, 1000 ),
              


               
               -- VehicleBuyMenuEntry( 78, 1100 ),
               --VehicleBuyMenuEntry( 79, 1300 ),
               
               -- VehicleBuyMenuEntry( 91, 1000 ),
                -- DLC
                --VehicleBuyMenuEntry( 20, 8000 ),
                --VehicleBuyMenuEntry( 58, 2000 ),
                --VehicleBuyMenuEntry( 75, 1000 ),
                --VehicleBuyMenuEntry( 82, 1000 )
            },

            ["Sea"] = {
                VehicleBuyMenuEntry( 5, 0),
				VehicleBuyMenuEntry( 50, 0),
				VehicleBuyMenuEntry( 28, 0 ),
				VehicleBuyMenuEntry( 80, 25),
				VehicleBuyMenuEntry( 27, 50 ),
                VehicleBuyMenuEntry( 16, 100),
                VehicleBuyMenuEntry( 69, 100), 
                VehicleBuyMenuEntry( 88, 200),
                -- DLC
                --VehicleBuyMenuEntry( 53, 10000 )
            },

            ["Air"] = {
                VehicleBuyMenuEntry( 3, 50),
				VehicleBuyMenuEntry( 65, 100 ),
				VehicleBuyMenuEntry( 81, 150 ),
				VehicleBuyMenuEntry( 64, 200 ),       
                VehicleBuyMenuEntry( 30, 200),
                VehicleBuyMenuEntry( 34, 300),
                --VehicleBuyMenuEntry( 85, 10000 ),
                -- DLC
                --VehicleBuyMenuEntry( 24, 15000 )
            }
        },

        [self.types.Weapon] = {
            { "One-handed", "Two-handed" },
            ["One-handed"] = {
                WeaponBuyMenuEntry( Weapon.Handgun, 0, 1, "Pistol" ),
                WeaponBuyMenuEntry( Weapon.Revolver, 25, 1, "Revolver" ),
                WeaponBuyMenuEntry( Weapon.SMG, 50, 1, "SMG" ),
                WeaponBuyMenuEntry( Weapon.SawnOffShotgun, 100, 1, "Sawn-off Shotgun" )
            },

            ["Two-handed"] = {
                WeaponBuyMenuEntry( Weapon.Assault, 150, 2, "Assault Rifle" ),
                WeaponBuyMenuEntry( Weapon.Shotgun, 25, 2, "Shotgun" ),
                WeaponBuyMenuEntry( Weapon.MachineGun, 200, 2, "Machine Gun" ),
                WeaponBuyMenuEntry( Weapon.Sniper, 150, 2, "Sniper Rifle" ),
                WeaponBuyMenuEntry( Weapon.RocketLauncher, 300, 2, "Rocket Launcher" )
            }
        },

        [self.types.Model] = {
            { "Roaches", "Ular Boys", "Reapers", "Government", "Agency", "Misc" },

            ["Roaches"] = {
            },

            ["Ular Boys"] = {

            },

            ["Reapers"] = {

            },

            ["Government"] = {
                ModelBuyMenuEntry( 74, 10000, "Baby Panay" ),
            },

            ["Agency"] = {
            },

            ["Misc"] = {
                
                
            }
        }
    }
end