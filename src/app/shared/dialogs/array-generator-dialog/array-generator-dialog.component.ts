import { Component, OnInit, Inject } from '@angular/core';

import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';

import { GeneratorService } from '../../services/generator/generator.service';


@Component({
  selector: 'app-array-generator-dialog',
  templateUrl: './array-generator-dialog.component.html',
  styleUrls: ['./array-generator-dialog.component.css']
})
export class ArrayGeneratorDialogComponent implements OnInit {

  constructor(
    public dialogRef: MatDialogRef<ArrayGeneratorDialogComponent>,
    public _generatorService: GeneratorService,
  ) { }

  ngOnInit() {
  }

  onNoClick(): void {
    this.dialogRef.close();
  }

}
