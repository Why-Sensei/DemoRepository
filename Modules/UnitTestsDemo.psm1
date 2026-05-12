class MyClass {
    hidden static [PSCustomObject]$someStaticVariable
    hidden [System.Collections.Generic.List[String]]$someVariable1
    hidden [String]$someVariable2
    hidden [Int]$someVariable3


    [System.Collections.Generic.List[String]] GetVar1() {
        return $this.someVariable1
    }

    [String] GetVar2() {
        return $this.someVariable2
    }

    [Int] GetVar3() {
        return $this.someVariable3
    }

    [Void] AddToVar3([Int]$valNum) {

        if ($valNum -lt 0) {
            throw [System.ArgumentOutOfRangeException]::New("Der übergebene Wert muss positiv sein!")
        }

        $this.someVariable3 += $valNum
    }

    [String] ToString() {
        return (($this.someVariable1 -join ",") + $this.someVariable2 + $this.someVariable3).Trim()
    }
}

class MyDerivedClass : MyClass {
    hidden [String]$someVariable4
    hidden [System.Collections.Hashtable]$someVariable5
    hidden [DateTime]$someVariable6


    MyDerivedClass([String]$valTxt, [DateTime]$valDT) {
        $this.someVariable4 = $valTxt
        $this.someVariable6 = $valDT
        $this.someVariable5 = @{}
    }


    [String] GetVar4() {
        return $this.someVariable4
    }

    [Hashtable] GetVar5() {
        return $this.someVariable5
    }

    [String] GetVar6() {
        return $this.someVariable6
    }

    [Void] SetVar6([System.DateTime]$valDT) {
        $this.someVariable6 = $valDT
    }

    [Void] AddToVar5([String]$key, [String]$val) {
        $this.someVariable5.Add($key, $val)
    }

    [String] ToString() {
        $htStr = "@{"

        foreach ($k in $this.someVariable5.GetEnumerator()) {
            if ($htStr -eq "") {
                $htStr = "@{" + $k + "=" + $this.someVariable5[$k]
            } else {
                $htStr = $htStr + "; " + $k + "=" + $this.someVariable5[$k]
            }
        }

        $htStr += "}"

        return $this.someVariable4 + $htStr + $this.someVariable6
    }
}
