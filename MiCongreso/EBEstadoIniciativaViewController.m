//
//  EBEstadoIniciativaViewController.m
//  MiCongreso
//
//  Created by Edu on 23/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import "EBEstadoIniciativaViewController.h"

@interface EBEstadoIniciativaViewController ()

@end

@implementation EBEstadoIniciativaViewController

@synthesize estado;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    self.navigationItem.title = @"Estado";
    
    NSString *estadoRaw = [self.estado lowercaseString];
    
    
    if ([estadoRaw rangeOfString:@"mesa directiva"].location != NSNotFound) {
        index = 0;
        
    }else if([estadoRaw rangeOfString:@"comisión"].location != NSNotFound){
        index = 1;
    }else if([estadoRaw rangeOfString:@"pleno"].location != NSNotFound){
        index = 2;
    }else if([estadoRaw rangeOfString:@"proyecto"].location != NSNotFound){
        index = 3;
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Presentación";
        case 1:
            return @"Comisión";
        case 2:
            return @"En pleno";
        case 3:
            return @"Proyecto";
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 10;
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
    if (indexPath.section<=index) {
        cell.textLabel.textColor = [UIColor whiteColor];
        switch (indexPath.section) {
            case 0:
                cell.backgroundColor = [UIColor colorWithRed:0.969 green:0.686 blue:0.318 alpha:1.000];
                break;
            case 1:
                cell.backgroundColor = [UIColor colorWithRed:0.793 green:0.562 blue:0.261 alpha:1.000];
                break;
            case 2:
                cell.backgroundColor = [UIColor colorWithRed:0.616 green:0.436 blue:0.202 alpha:1.000];
                break;
            case 3:
                cell.backgroundColor = [UIColor colorWithRed:0.453 green:0.321 blue:0.149 alpha:1.000];
                break;
            default:
                break;
        }
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"Fecha en que la Mesa Directiva de la Cámara turna la iniciativa a las comisiones, para su estudio, discusión y dictaminación.";
            break;
        case 1:
            cell.textLabel.text = @"En esta etapa se analiza y se discute el contenido de la iniciativa, para hacer un dictamen o desecharla.";
            break;
        case 2:
            cell.textLabel.text = @"El dictamen preparado por la comisión correspondiente se presenta ante todos los diputados para su discusión y aprobación o descarte.";
            break;
        case 3:
            cell.textLabel.text = @"El dictamen se convierte en proyecto y pasa a la cámara revisora. Si es una minuta, se envía al Ejecutivo.";
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0f;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
