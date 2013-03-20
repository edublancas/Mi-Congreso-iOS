//
//  EBIniciativaDetallesTableViewController.m
//  MiCongreso
//
//  Created by Edu on 17/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import "EBIniciativaDetallesTableViewController.h"

#define kFontSize 15.0f
#define kTopMargin 5.0f
#define kBottomMargin 5.0f

@interface EBIniciativaDetallesTableViewController ()

@end

@implementation EBIniciativaDetallesTableViewController

@synthesize iniciativa;



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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Detalles";
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
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 4:
            if (iniciativa.plenoAbstenciones && iniciativa.plenoAFavor && iniciativa.plenoEnContra) {
                return 3;
            }else{
                return 1;
            }
            break;
        case 5:
            return 2;
        default:
            return 1;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Fecha";
            break;
        case 1:
            return @"Propuesta por";
            break;
        case 2:
            return @"Descripción";
            break;
        case 3:
            return @"Estado de la iniciativa";
            break;
        case 4:
            return @"Votación oficial";
            break;
        case 5:
            return @"Votación en curul 501";
            break;
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = iniciativa.fecha;
            break;
        case 1:
            cell.textLabel.text = iniciativa.nombreCongresista;
            break;
        case 2:
            cell.textLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
            cell.textLabel.numberOfLines = 10;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = iniciativa.descripcion;
            break;
        case 3:
            cell.textLabel.text = iniciativa.estado;
            break;
        case 4:
            if (iniciativa.plenoAbstenciones && iniciativa.plenoAFavor && iniciativa.plenoEnContra) {
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = [NSString stringWithFormat:@"Votos a favor: %d", iniciativa.plenoAFavor];
                        break;
                    case 1:
                        cell.textLabel.text = [NSString stringWithFormat:@"Votos en contra: %d", iniciativa.plenoEnContra];
                        break;
                    case 2:
                        cell.textLabel.text = [NSString stringWithFormat:@"Abstenciones: %d", iniciativa.plenoAbstenciones];
                        break;
                    default:
                        break;
                }
            }else{
                cell.textLabel.text = @"Esta iniciativa no ha sido votada";
            }
            
            break;
        case 5:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"Votos a favor: %d", iniciativa.localAFavor];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"Votos en contra: %d", iniciativa.localEnContra];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section==2) {
        CGSize maxSize = CGSizeMake(280.0f, 200.0f);
        CGSize size = [iniciativa.descripcion sizeWithFont:[UIFont boldSystemFontOfSize:kFontSize] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
        
        return size.height+kTopMargin+kBottomMargin;
        
    }else{
        return 46.0f;
    }
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
