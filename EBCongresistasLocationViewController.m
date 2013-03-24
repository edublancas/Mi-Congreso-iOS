//
//  EBCongresistasLocationViewController.m
//  MiCongreso
//
//  Created by Edu on 22/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import "EBCongresistasLocationViewController.h"

@interface EBCongresistasLocationViewController ()

@end

@implementation EBCongresistasLocationViewController

@synthesize diputados, senadores, estado;

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

    self.navigationItem.title = estado;
    
    senadoresLocation = [[NSMutableArray alloc]init];
    diputadosLocation = [[NSMutableArray alloc]init];
    
    NSArray *diputadosKeys = [[diputados allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    for (int i = 0; i<diputadosKeys.count; i++) {
        NSArray *diputadosArray = [diputados objectForKey:[diputadosKeys objectAtIndex:i]];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for (EBCongresista *diputado in diputadosArray) {
            if ([diputado.estado isEqualToString:estado]) {
                [temp addObject:diputado];
            }
        }
        if (temp.count) {
            [diputadosLocation addObjectsFromArray:temp];
        }
    }
    
    
    NSArray *senadoresKeys = [[senadores allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    for (int i = 0; i<senadoresKeys.count; i++) {
        NSArray *senadoresArray = [senadores objectForKey:[senadoresKeys objectAtIndex:i]];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for (EBCongresista *senador in senadoresArray) {
            if ([senador.estado isEqualToString:estado]) {
                [temp addObject:senador];
            }
        }
        if (temp.count) {
            [senadoresLocation addObjectsFromArray:temp];
        }
    }
    
    //NSLog(@"%@ Senadores: %@ Diputados: %@", estado, senadoresLocation, diputadosLocation);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	if (section==0) {
        return [NSString stringWithFormat:@"Total: %d", senadoresLocation.count];
    }else{
        return [NSString stringWithFormat:@"Total: %d", diputadosLocation.count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return senadoresLocation.count;
        case 1:
            return diputadosLocation.count;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Senadores";
        case 1:
            return @"Diputados";
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [[senadoresLocation objectAtIndex:indexPath.row]nombre];
            break;
        case 1:
            cell.textLabel.text = [[diputadosLocation objectAtIndex:indexPath.row]nombre];
            break;
        default:
            break;
    }
    
    return cell;
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

    EBCongresistaDetailViewController *detailViewController = [[EBCongresistaDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
    
    if (indexPath.section==0) {
        detailViewController.congresista = [senadoresLocation objectAtIndex:indexPath.row];
    }else{
        detailViewController.congresista = [diputadosLocation objectAtIndex:indexPath.row];
    }
    
    [detailViewController.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

@end
