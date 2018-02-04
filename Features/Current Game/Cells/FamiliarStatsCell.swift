//
//  CharacterStatsCell.swift
//  Judgement
//
//  Created by Oliver Hauth on 04.02.18.
//  Copyright © 2018 nogoodname. All rights reserved.
//

import UIKit

protocol FamiliarStatsCellDelegate {
    func deleteButtonTouched(sender aSender: FamiliarStatsCell)
    func damageIncreased(sender aSender: FamiliarStatsCell)
    func damageDecreased(sender aSender: FamiliarStatsCell)
    func revive(sender aSender: FamiliarStatsCell)
}

class FamiliarStatsCell: UICollectionViewCell {
    var state: CharacterState? = nil {
        didSet {
            if self.state != nil {
                updateCell()
            }
        }
    }
    
    var indexPath: Int? = nil {
        didSet {
            if let indexPath = self.indexPath {
                self.tag = indexPath
                self.detailsButton.tag = indexPath
                self.removeButton.tag = indexPath
            }
        }
    }
    
    
    var delegate: FamiliarStatsCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var traitLabel: UILabel!
    
    @IBOutlet weak var statMovLabel: UILabel!
    @IBOutlet weak var statAgiLabel: UILabel!
    @IBOutlet weak var statResLabel: UILabel!
    @IBOutlet weak var statMelLabel: UILabel!
    @IBOutlet weak var statMagLabel: UILabel!
    @IBOutlet weak var statRngLabel: UILabel!
    @IBOutlet weak var statLifeLeftLabel: UILabel!
    
    @IBOutlet weak var weapon1Name: UILabel!
    @IBOutlet weak var weapon1Type: UILabel!
    @IBOutlet weak var weapon1Cost: UILabel!
    @IBOutlet weak var weapon1Range: UILabel!
    @IBOutlet weak var weapon1Glance: UILabel!
    @IBOutlet weak var weapon1Solid: UILabel!
    @IBOutlet weak var weapon1Crit: UILabel!
    
    @IBOutlet weak var weapon2Name: UILabel!
    @IBOutlet weak var weapon2Type: UILabel!
    @IBOutlet weak var weapon2Cost: UILabel!
    @IBOutlet weak var weapon2Range: UILabel!
    @IBOutlet weak var weapon2Glance: UILabel!
    @IBOutlet weak var weapon2Solid: UILabel!
    @IBOutlet weak var weapon2Crit: UILabel!
    
    @IBOutlet weak var weapon3Name: UILabel!
    @IBOutlet weak var weapon3Type: UILabel!
    @IBOutlet weak var weapon3Cost: UILabel!
    @IBOutlet weak var weapon3Range: UILabel!
    @IBOutlet weak var weapon3Glance: UILabel!
    @IBOutlet weak var weapon3Solid: UILabel!
    @IBOutlet weak var weapon3Crit: UILabel!
    
    
    var weaponRows: [WeaponRow] = []
    
    @IBOutlet weak var damageTakenLabel: UILabel!
    
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var statsView: UIView!
    
    func updateCell() {
        self.nameLabel!.text = self.state!.character!.name
        self.roleLabel!.text = self.state!.character!.battlefieldRole.rawValue
        self.traitLabel!.text = String(format: "%@ %@", self.state!.character!.race, self.state!.character!.trait)
        
        let movStat = self.state!.get(stat: .mov)
        self.statMovLabel!.text = movStat.value
        self.statMovLabel!.textColor = movStat.color
        
        let agiStat = self.state!.get(stat: .agi)
        self.statAgiLabel!.text = agiStat.value
        self.statAgiLabel!.textColor = agiStat.color
        
        let resStat = self.state!.get(stat: .res)
        self.statResLabel!.text = resStat.value
        self.statResLabel!.textColor = resStat.color
        
        let melStat = self.state!.get(stat: .mel)
        self.statMelLabel!.text = melStat.value
        self.statMelLabel!.textColor = melStat.color
        
        let magStat = self.state!.get(stat: .mag)
        self.statMagLabel!.text = magStat.value
        self.statMagLabel!.textColor = magStat.color
        
        let rngStat = self.state!.get(stat: .rng)
        self.statRngLabel!.text = rngStat.value
        self.statRngLabel!.textColor = rngStat.color
        
        self.statLifeLeftLabel!.text = String(self.currentLifeLeft())
        
        self.damageTakenLabel!.text = String(self.state!.damageTaken)
        self.statLifeLeftLabel!.textColor = (self.currentLifeLeft() == 0) ? UIColor.red : UIColor.lightGray
        self.statLifeLeftLabel!.text = String(self.currentLifeLeft())
        
        self.blurView.alpha = (self.currentLifeLeft() == 0) ? 1.0 : 0.0
        
        for i in 0 ..< weaponRows.count {
            self.weaponRows[i].nameLabel.text = (self.state!.character!.attacks.count > i) ? self.state!.character!.attacks[i].name : ""
            self.weaponRows[i].typeLabel.text = (self.state!.character!.attacks.count > i) ? AttackTypeNames[self.state!.character!.attacks[i].type.rawValue] : ""
            self.weaponRows[i].costLabel.text = (self.state!.character!.attacks.count > i) ? self.state!.character!.attacks[i].cost : ""
            self.weaponRows[i].rangeLabel.text = (self.state!.character!.attacks.count > i) ? self.state!.character!.attacks[i].range : ""
            self.weaponRows[i].glanceLabel.text = (self.state!.character!.attacks.count > i) ? self.state!.character!.attacks[i].glanceDamage : ""
            self.weaponRows[i].solidLabel.text = (self.state!.character!.attacks.count > i) ? self.state!.character!.attacks[i].solidDamage : ""
            self.weaponRows[i].critLabel.text = (self.state!.character!.attacks.count > i) ? self.state!.character!.attacks[i].critDamage : ""
        }
        
        self.setNeedsDisplay()
    }
    
    func initializeCell(withCharacter aCharacter: CharacterState) {
        self.weaponRows = [
            WeaponRow(nameLabel: self.weapon1Name, typeLabel: self.weapon1Type, costLabel: self.weapon1Cost, rangeLabel: self.weapon1Range, glanceLabel: self.weapon1Glance, solidLabel: self.weapon1Solid, critLabel: self.weapon1Crit),
            WeaponRow(nameLabel: self.weapon2Name, typeLabel: self.weapon2Type, costLabel: self.weapon2Cost, rangeLabel: self.weapon2Range, glanceLabel: self.weapon2Glance, solidLabel: self.weapon2Solid, critLabel: self.weapon2Crit),
            WeaponRow(nameLabel: self.weapon3Name, typeLabel: self.weapon3Type, costLabel: self.weapon3Cost, rangeLabel: self.weapon3Range, glanceLabel: self.weapon3Glance, solidLabel: self.weapon3Solid, critLabel: self.weapon3Crit)
        ]
        
        self.state = aCharacter
    }
    
    func currentLifeLeft() -> Int {
        var baseLife = 0
        
        switch (self.state!.currentLevel) {
        case 1:
            baseLife = Int(self.state!.character!.lifeLevel1)
        case 2:
            baseLife = Int(self.state!.character!.lifeLevel2)
        default:
            baseLife = Int(self.state!.character!.lifeLevel3)
        }
        
        return baseLife - self.state!.damageTaken
    }
    
    @IBAction func removeButtonTouched(_ sender: UIButton) {
        self.delegate?.deleteButtonTouched(sender: self)
    }
    
    @IBAction func damageDecrease(_ sender: UIButton) {
        self.delegate?.damageDecreased(sender: self)
    }
    
    @IBAction func damageIncrease(_ sender: UIButton) {
        self.delegate?.damageIncreased(sender: self)
    }
    
    @IBAction func reviveButtonTouched(_ sender: UIButton) {
        self.delegate?.revive(sender: self)
    }
}

